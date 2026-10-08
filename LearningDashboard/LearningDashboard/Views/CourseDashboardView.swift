import SwiftUI

struct CourseDashboardView: View {
    @StateObject private var viewModel = CourseDashboardViewModel()
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading Courses...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
            case .empty:
                VStack {
                    Image(systemName: "tray")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No courses available.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
            case .error(let message):
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.red)
                    Text(message).foregroundColor(.red)
                    Button("Retry") {
                        Task { await viewModel.loadCourses() }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
            case .loaded:
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.courses) { course in
                            NavigationLink(destination: CourseDetailsView(course: course)) {
                                CourseRow(course: course)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
                .refreshable {
                    await viewModel.refresh()
                }
            }
        }
        .navigationTitle("My Courses")
        .navigationBarBackButtonHidden(true)
        .task {
            if viewModel.courses.isEmpty {
                await viewModel.loadCourses()
            }
        }
        .onAppear {
            if viewModel.courses.count > 0 {
                viewModel.reloadFromCache()
            }
        }
    }
}

struct CourseRow: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header: Title and Instructor
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(course.title ?? "Unknown Course")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(course.instructor ?? "Unknown Instructor")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                
                // Icon representing the course
                Image(systemName: "book.closed.fill")
                    .foregroundColor(.blue)
                    .padding(12)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }
            
            // Progress Section
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Progress")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(course.progress ?? 0)%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor((course.progress ?? 0) == 100 ? .green : .blue)
                }
                
                ProgressView(value: Double(course.progress ?? 0), total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: (course.progress ?? 0) == 100 ? .green : .blue))
                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
            }
            .padding(.vertical, 4)
            
            Divider()
            
            // Footer: Lessons count and Continue Button
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "play.rectangle.fill")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text("\(course.lessonsCount ?? 0) Lessons")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text((course.progress ?? 0) == 100 ? "Review" : "Continue")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background((course.progress ?? 0) == 100 ? Color.green.opacity(0.1) : Color.blue.opacity(0.1))
                    .foregroundColor((course.progress ?? 0) == 100 ? .green : .blue)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
