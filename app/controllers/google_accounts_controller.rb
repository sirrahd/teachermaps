class GoogleAccountsController < ApplicationController
  # GET /google_accounts
  # GET /google_accounts.json
  def index
    @google_accounts = GoogleAccount.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @google_accounts }
    end
  end

  # GET /google_accounts/1
  # GET /google_accounts/1.json
  def show
    @google_account = GoogleAccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @google_account }
    end
  end

  # GET /google_accounts/new
  # GET /google_accounts/new.json
  def new
    @google_account = GoogleAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @google_account }
    end
  end

  # GET /google_accounts/1/edit
  def edit
    @google_account = GoogleAccount.find(params[:id])
  end

  # POST /google_accounts
  # POST /google_accounts.json
  def create
    @google_account = GoogleAccount.new(params[:google_account])

    respond_to do |format|
      if @google_account.save
        format.html { redirect_to @google_account, notice: 'Google account was successfully created.' }
        format.json { render json: @google_account, status: :created, location: @google_account }
      else
        format.html { render action: "new" }
        format.json { render json: @google_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /google_accounts/1
  # PUT /google_accounts/1.json
  def update
    @google_account = GoogleAccount.find(params[:id])

    respond_to do |format|
      if @google_account.update_attributes(params[:google_account])
        format.html { redirect_to @google_account, notice: 'Google account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @google_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /google_accounts/1
  # DELETE /google_accounts/1.json
  def destroy
    @google_account = GoogleAccount.find(params[:id])
    @google_account.destroy

    respond_to do |format|
      format.html { redirect_to google_accounts_url }
      format.json { head :no_content }
    end
  end
end
