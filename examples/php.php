<?php

declare(strict_types=1);
final class ProjectSummary
{
	/**
	 * @param array<int, array<string, mixed>> $lstTasks
	 */
	public function __construct(
		private readonly string $Name,
		private readonly array $lstTasks,
	) {
	}
	/**
	 * Возвращает долю завершённых задач в процентах.
	 */
	public function getProgress(): int
	{
		$TotalCount = count($this->lstTasks);
		$CompletedCount = 0;
		foreach ($this->lstTasks as $dctTask) {
			if (($dctTask['status'] ?? null) === 'done') {
				$CompletedCount++;
			}
		}
		return $TotalCount > 0 ? (int) round($CompletedCount / $TotalCount * 100) : 0;
	}
	/**
	 * Формирует данные для карточки проекта.
	 *
	 * @return array{name: string, progress: int, pending: int}
	 */
	public function toArray(): array
	{
		$Progress = $this->getProgress();
		$PendingCount = count($this->lstTasks) - (int) round($Progress * count($this->lstTasks) / 100);
		return [
			'name' => $this->Name,
			'progress' => $Progress,
			'pending' => $PendingCount,
		];
	}
}
$lstTasks = [
	['title' => 'Проверить контрастность', 'status' => 'done'], ['title' => 'Обновить документацию', 'status' => 'in-progress'],
	['title' => 'Подготовить релиз', 'status' => 'todo'],
	['title' => 'Собрать обратную связь', 'status' => 'done'],
];
$projectSummary = new ProjectSummary('Green Paper', $lstTasks); $dctSummary = $projectSummary->toArray();
header('Content-Type: application/json; charset=utf-8'); echo json_encode($dctSummary, JSON_THROW_ON_ERROR | JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
