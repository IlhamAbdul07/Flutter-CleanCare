import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/tasks_controller.dart';
import 'package:flutter_cleancare/data/models/tasks_model.dart';
import 'package:flutter_cleancare/pages/add_task_page.dart';
import 'package:flutter_cleancare/pages/detail_task_page.dart';
import 'package:get/get.dart';

class TaskManagementPage extends StatelessWidget {
  const TaskManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskC = Get.put(TaskController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'Task Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              children: [
                // 🔍 Search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari tugas...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: taskC.searchTask,
                ),
                const SizedBox(height: 8),

                Expanded(
                  child: Obx(() {
                    final tasks = taskC.tasks;
            
                    return RefreshIndicator(
                      onRefresh: () async {
                        await taskC.refreshTasks();
                      },
                      child: tasks.isEmpty
                          ? const Center(child: Text("Mohon tunggu, sedang menyiapkan data."))
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 10,
                              ),
                              child: ListView.builder(
                                itemCount: tasks.length,
                                itemBuilder: (context, index) {
                                  final task = tasks[index];
                                  return _buildTaskTile(task);
                                },
                              ),
                            ),
                    );
                  }),
                ),
              ],
            ),

            // positioned
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  color: Colors.white,
                  iconSize: 28,
                  icon: const Icon(Icons.add),
                  tooltip: 'Tambah Tugas',
                  onPressed: () async {
                    final result = await Get.to(() => AddTaskPage());
                    if (result == true) {
                      taskC.refreshTasks();
                    }else{
                      taskC.refreshTasks();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget terpisah agar rapi
  Widget _buildTaskTile(Tasks task) {
    final taskC = Get.put(TaskController());

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(int.parse(task.taskId) == 1 ? Icons.cleaning_services : Icons.work),
        title: Text(task.name),
        subtitle: Text(task.taskName),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        onTap: () async {        
          final result = await Get.to(() => DetailTaskPage(id: int.parse(task.id),name: task.name,taskId: int.parse(task.taskId),taskName: task.taskName,));
          if (result == true) {
            taskC.refreshTasks();
          }else{
            taskC.refreshTasks();
          }
        },
      ),
    );
  }
}
