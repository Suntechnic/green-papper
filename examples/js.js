const project = {
	name: 'Green Paper',
	owner: 'anna.smirnova@example.com',
	tasks: [
		{ id: 1, title: 'Проверить контрастность', status: 'done', priority: 'high' },
		{ id: 2, title: 'Обновить документацию', status: 'in-progress', priority: 'normal' },
		{ id: 3, title: 'Подготовить релиз', status: 'todo', priority: 'high' },
	],
};
class TaskBoard {
	#tasks;
	#listeners = new Set();
	constructor(tasks = []) {
		this.#tasks = structuredClone(tasks);
	}
	get completedCount() {
		return this.#tasks.filter(({ status }) => status === 'done').length;
	}
	subscribe(listener) {
		this.#listeners.add(listener);
		return () => this.#listeners.delete(listener);
	}
	updateStatus(taskId, status) {
		const task = this.#tasks.find(({ id }) => id === taskId);
		if (!task || !['todo', 'in-progress', 'done'].includes(status)) {
			throw new Error(`Не удалось обновить задачу #${taskId}`);
		}
		task.status = status;
		this.#listeners.forEach((listener) => listener(task, this.completedCount));
	}

	async sync() {
		const response = await fetch('/api/tasks', {
			method: 'PUT',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify(this.#tasks),
		});
		if (!response.ok) throw new Error(`Ошибка синхронизации: ${response.status}`);
		return response.json();
	}
}

const board = new TaskBoard(project.tasks);
const unsubscribe = board.subscribe((task, completedCount) => {
	console.info(`Задача «${task.title}» теперь ${task.status}. Выполнено: ${completedCount}`);
});
document.querySelector('[data-task="release"]')?.addEventListener('click', async () => {
	board.updateStatus(3, 'done');
	await board.sync();
});
