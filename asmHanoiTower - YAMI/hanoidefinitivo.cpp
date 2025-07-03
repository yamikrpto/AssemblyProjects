#include <iostream>
#include<cmath>

using namespace std;

void TorreHanoi (int n, char origem, char auxiliar, char objetivo);


int main(){
char origem = 'A';
char auxiliar = 'B';
char objetivo = 'C';
int n_discos = 0;


cout<<"Quantos discos tem seu problema? (1-5)"<<endl;
cin>>n_discos;
    if(n_discos >= 1 && n_discos <=5){
    system("clear");

    cout<<endl;
    cout << "Movimentos necessários para resolver a Torrs de Hanoi com " << n_discos << " discos: " << (pow(2, n_discos) - 1) << endl;
    cout<<endl;

    TorreHanoi(n_discos, origem , auxiliar, objetivo);
    } if(n_discos>5) {
    system("clear");
    cout<<endl;
    cout<<"Erro de execução. O programa só suporta uma resolução de até 5 discos";
    cout<<endl;
    } if(n_discos<=0){
    system("clear");
    cout<<endl;
    cout<<"Erro. O número de discos não pode ser zero ou negativo!";
    cout<<endl;
    }

return 0;

}

void TorreHanoi(int n, char origem, char auxiliar, char objetivo){
    if(n==1){
    cout<<"Mover disco 1 da torre " <<origem<<" para torre "<<objetivo<<endl;
    return;
    }
    TorreHanoi( n-1,  origem,  objetivo,  auxiliar);
    cout<<"Mover disco "<<n<<" da torre "<< origem<<" para torre "<<objetivo<<endl;
    TorreHanoi( n-1,  auxiliar, origem, objetivo);
}
