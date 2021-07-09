# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "-----------------------"
puts "Cadastrando USERS..."
User.create!(first_name: "Davide", last_name: "Almeida", email: "davide@davide.com.br", password: "123456", password_confirmation: "123456")
User.create!(first_name: "Matheus", last_name: "Paulino", email: "mnatheus@matheus.com.br", password: "123456", password_confirmation: "123456")
puts "USERS cadastrados!"
puts "-----------------------"

puts "-----------------------"
puts "Cadastrando Company..."
Company.create!(name: "Empresa 1", description: "Descrição da empresa 1", user_id: 1)
# Company.create!(name: "Empresa 2", description: "Descrição da empresa 2", user_id: 1)
puts "Company cadastrados!"
puts "-----------------------"

puts "-----------------------"
puts "Cadastrando Projects..."
#Project.create!(name: "Projeto 1", description: "Descrição do Projeto 1", hour_price_cents: 1000, pay_day: DateTime.now + 2.day, status: 0, company_id: 1, user_id: 1)
Project.create!(name: "Projeto 1", description: "Descrição do Projeto 1", payment_type: 0, status: 0, company_id: 1, user_id: 1)
#Project.create!(name: "Projeto 2", description: "Descrição do Projeto 2", payment_type: 0, status: 0, company_id: 2, user_id: 1)
#Project.create!(name: "Projeto 3", description: "Descrição do Projeto 3", payment_type: 0, status: 0, company_id: 2, user_id: 1)
puts "Projects cadastrados!"
puts "-----------------------"

puts "-----------------------"
puts "Cadastrando Tasks..."
Task.create!(name: "Tarefa 1", project_id: 1, status: 0, user_id: 1, company_id: 1)
# Task.create!(name: "Tarefa 2", project_id: 1, status: 0, user_id: 1, company_id: 1)
# Task.create!(name: "Tarefa 3", project_id: 1, status: 0, user_id: 1, company_id: 1)
puts "Tasks cadastrados!"
puts "-----------------------"

puts "-----------------------"
puts "Cadastrando TaskSchedules..."
@default_dateTime = DateTime.now
@array_dateTime = []
@array_dateTime << @default_dateTime + 4.hour
@array_dateTime << @default_dateTime + 1.day

# @start_date = []
# @start_time = []
# @start_date << @array_dateTime[0].strftime('%d/%m/%Y')
# @start_time << @array_dateTime[0].strftime('%H:%M:%S')

# @end_date = []
# @end_time = []
# @end_date << @array_dateTime[1].strftime('%d/%m/%Y')
# @end_time << @array_dateTime[1].strftime('%H:%M:%S')

# Example convert DateTime to seconds and seconds to DateTime:
# teste = (DateTime.now + 4.day)
# teste.to_i
# Time.at(teste).to_datetime

#TaskSchedule.create!(start_date: @default_dateTime, end_date: @array_dateTime[0], work_hour: "04:00:00", task_id: 1)
#TaskSchedule.create!(start_date: @default_dateTime, end_date: @array_dateTime[1], work_hour: "24:00:00", task_id: 2)
# TaskSchedule.create!(start_date: Time.zone.now - 6.hour, end_date: Time.zone.now - 3.hour, work_hour: "03:00:00", task_id: 1)
# TaskSchedule.create!(start_date: Time.zone.now - 3.hour, end_date: Time.zone.now - 2.hour, work_hour: "02:00:00", task_id: 2)
# TaskSchedule.create!(start_date: Time.zone.now - 1.hour, end_date: Time.zone.now, work_hour: "01:00:00", task_id: 3)
puts "TaskSchedules cadastrados!"
puts "-----------------------"

puts "-----------------------"
puts "Cadastrando ByHours..."
ByHour.create!(
    hour_price_cents: 1000,
    recurrence: 3,
    start_pay_day: "2021-07-05", #Time.zone.now.to_date + 1.month,
    start_invoice_day: "2021-07-01", #Time.zone.now.to_date + 1.month - 4.days,
    project_id: 1
)
puts "ByHours cadastradas!"
puts "-----------------------"

puts "-----------------------"
puts "Cadastrando InPayments..."
InPayment.create!(project_id: 1, user_id: 1)
InPayment.create!(project_id: 1, user_id: 1)
# InPayment.create!(project_id: 1, user_id: 1)
# InPayment.create!(project_id: 1, user_id: 1)
# InPayment.create!(project_id: 1, user_id: 1)
# InPayment.create!(project_id: 1, user_id: 1)
puts "InPayments cadastradas!"
puts "-----------------------"

puts "-----------------------"
puts "Cadastrando InParcels..."
InParcel.create!(in_payment_id: 1, value_cents: 0, status: 0, parcel_number: 1, due_date: "2021-08-05", invoice_due_date: "2021-08-01", paid_day: nil)
InParcel.create!(in_payment_id: 2, value_cents: 0, status: 0, parcel_number: 2, due_date: "2021-07-05", invoice_due_date: "2021-07-01", paid_day: nil)
# InParcel.create!(in_payment_id: 2, value_cents: 1000, status: 1, parcel_number: 1, due_date: "2021-04-05", invoice_due_date: "2021-04-01", paid_day: "2021-04-05")
# InParcel.create!(in_payment_id: 3, value_cents: 3000, status: 1, parcel_number: 1, due_date: "2021-05-05", invoice_due_date: "2021-05-01", paid_day: "2021-05-05")
# InParcel.create!(in_payment_id: 4, value_cents: 2000, status: 1, parcel_number: 1, due_date: "2021-06-05", invoice_due_date: "2021-06-01", paid_day: "2021-06-05")
# InParcel.create!(in_payment_id: 5, value_cents: 6000, status: 0, parcel_number: 1, due_date: "2021-07-05", invoice_due_date: "2021-07-01", paid_day: nil)
puts "InParcels cadastradas!"
puts "-----------------------"

puts "-----------------------"
puts "Cadastrando Goals..."
# Goal.create!(user_id: 1, goal_type:"Receita")
puts "Goals cadastradas!"
puts "-----------------------"

puts "-----------------------"
puts "Cadastrando GoalInPayments..."
# GoalInPayment.create!(goal_id: 1, goal_value_cents: 1000, start_date: Time.zone.now.at_beginning_of_month, end_date: Time.zone.now.at_end_of_month)
puts "GoalInPayments cadastradas!"
puts "-----------------------"

puts "-----------------------"
puts "Cadastrando Settings..."
Setting.create!(user_id: 1)
puts "Settings cadastradas!"
puts "-----------------------"