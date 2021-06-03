class App::DailyWorker
  include Sidekiq::Worker

  def perform(*args)
    InParcel.all.where("due_date < ?", Time.zone.now.to_date).where.not(status: "Pago", status: "Em atraso").update_all(status: "Em atraso")
    #puts "ENTROU NO App::DailyWorker !!!!!!!!!"
  end

end
