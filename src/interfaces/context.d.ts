import {ContextParameters} from 'graphql-yoga/dist/types';

export interface Context extends ContextParameters {
    user: any
}