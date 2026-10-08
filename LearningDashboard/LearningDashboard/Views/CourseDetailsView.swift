import SwiftUI

struct CourseDetailsView: View {
    @StateObject private var viewModel: CourseDetailsViewModel
    
    init(course: Course) {
        _viewModel = StateObject(wrappedValue: CourseDetailsViewModel(course: course))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header (Simple, No Gradient)
                VStack(alignment: .leading, spacing: 12) {
                    Text(viewModel.course.title ?? "Unknown Course")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    if let instructor = viewModel.course.instructor {
                        Text("Instructor: \(instructor)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Overall Progress:")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Spacer()
                            Text("\(viewModel.course.progress ?? 0)%")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        
                        ProgressView(value: Double(viewModel.course.progress ?? 0), total: 100)
                            .progressViewStyle(LinearProgressViewStyle(tint: (viewModel.course.progress ?? 0) == 100 ? .green : .blue))
                            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: viewModel.course.progress)
                    }
                    .padding(.top, 5)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Lessons Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Lessons")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        ForEach(viewModel.course.lessons ?? []) { lesson in
                            LessonRowView(lesson: lesson) {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    viewModel.toggleLesson(lessonId: lesson.id ?? 0)
                                }
                            }
                            
                            if lesson.id != viewModel.course.lessons?.last?.id {
                                Divider().padding(.horizontal, 16)
                            }
                        }
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                }
                
                Spacer().frame(height: 30)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Course Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LessonRowView: View {
    let lesson: Lesson
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(lesson.title ?? "Unknown Lesson")
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
                
                HStack(spacing: 6) {
                    if (lesson.isCompleted ?? false) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                        Text("Completed")
                            .font(.subheadline)
                    } else {
                        Image(systemName: "circle")
                            .font(.system(size: 14))
                        Text("Pending")
                            .font(.subheadline)
                    }
                }
                .foregroundColor((lesson.isCompleted ?? false) ? .green : .gray)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
