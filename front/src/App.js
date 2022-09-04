import './App.css';
import React from 'react';

function App() {
  const [data, setData] = React.useState([]);

  React.useEffect(() => {
    const url = `${process.env.REACT_APP_API_URL}/hello`;
    fetch(url)
      .then((response) => response.json())
      .then((json) => setData(json['message']))
      .catch((error) => console.log(error));
  }, []);

  return (
    <>
      <div className='header'>
        <h2>{ data }</h2>
      </div>
    </>
  );
}

export default App;
