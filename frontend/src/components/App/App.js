import { BrowserRouter as Router, Switch, Route } from "react-router-dom"
import ErrorBoundary from '../ErrorBoundary/ErrorBoundary'
import Book from '../Book/Book'
import Books from '../Books/Books'
import Page404 from '../Page404/Page404'
import Navbar from '../Common/Navbar/Navbar'
import css from './App.module.scss'

function App() {
  return (
    <ErrorBoundary>
      <Router>
        <Navbar />
        <div className={css.root}>
          <Switch>
            <Route exact path="/">
              <Books />
            </Route>
            <Route
              path="/books/new"
              render={props => <Book {...props} key={Date.now()} />}
            />
            <Route path="/books/:id">
              <Book />
            </Route>
            <Route component={Page404} />
          </Switch>
        </div>
      </Router>
    </ErrorBoundary>
  );
}

export default App
